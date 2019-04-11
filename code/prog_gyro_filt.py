#!/usr/bin/env python3
from ev3dev.ev3 import *
import math

k1 = 8
k2 = 0.5
k3 = 0.06
route = [[1.5, 0], [0, 0]]
#route = [[0.4, 0.4], [0.4, -0.4], [-0.4, -0.4], [-0.4, 0.4], [0.4, 0.4]]
voltage = 7.00
r = 0.02
B = 0.12
ok_zone = 0.05
min_dist = 35

mA = LargeMotor('outA')
mB = LargeMotor('outB')
us1 = UltrasonicSensor('in1')
us2 = UltrasonicSensor('in2')
us1.mode = 'US-DIST-CM'
us2.mode = 'US-DIST-CM'
gyro = GyroSensor('in3')
gyro.mode = 'GYRO-RATE'
fh = open('robot_data.txt', 'w')

desired_x = route[0][0]
desired_y = route[0][1]
current_x = 0
current_y = 0
complete = 0
mA.position = 0
mB.position = 0
prev_path = 0
integral = 0
gyro_angle = 0
last_gyro_angle_cut = 0

try:
    gvalues = 0
    for i in range(100):
        gvalues += gyro.value()
        time.sleep(0.01)
    init_gyro_offset = gvalues/100
    current_time = time.time()
    while complete < len(route):
        dt = time.time() - current_time
        current_time = time.time()
        motorA_pos = mA.position * math.pi / 180
        motorB_pos = mB.position * math.pi / 180
        dist1 = us1.value() / 10
        dist2 = us2.value() / 10
        gyro_raw = gyro.value()
        gyro_speed = (gyro_raw - init_gyro_offset) * math.pi / 180
        gyro_angle += gyro_speed * dt
        lp_gyro_angle = (1 - k_lp)*gyro_angle + k_lp*lp_gyro_angle;
        gyro_angle_cut = gyro_angle - lp_gyro_angle
        hp_gyro_angle = (1 - k_hp)*hp_gyro_angle + (1 - k_hp)*(gyro_angle_cut - last_gyro_angle_cut)
        last_gyro_angle_cut = gyro_angle_cut
        path = (motorA_pos + motorB_pos)*(r/2)
        dpath = path - prev_path
        prev_path = path
        current_x += dpath*math.cos(gyro_angle)
        current_y += dpath*math.sin(gyro_angle)
        dx = desired_x - current_x
        dy = desired_y - current_y
        path_err = math.sqrt(dx**2 + dy**2)
        need_angle = math.atan2(dy, dx)
        cur_dist = min(dist1, dist2)
        if(cur_dist < min_dist):
            dist_err = k3*(min_dist - cur_dist)*math.copysign(1, dist1 - dist2)
        else:
            dist_err = 0
        angle_err = need_angle - gyro_angle - dist_err
        if abs(angle_err) > math.pi:
            angle_err -= math.copysign(1, angle_err)*2*math.pi
        integral += path_err*0.007
        u_straight = voltage*math.tanh (path_err)*math.cos(angle_err) + k2*integral
        u_rotation = k1*angle_err + math.sin(angle_err)*u_straight/path_err
        sA = u_straight + u_rotation
        sB = u_straight - u_rotation
        sA = sA * 100 / voltage
        sB = sB * 100 / voltage
        if abs(sA) > 100:
            sA = math.copysign(100, sA)
        if abs(sB) > 100:
            sB = math.copysign(100, sB)
        mA.run_direct(duty_cycle_sp=sA)
        mB.run_direct(duty_cycle_sp=sB)
        fh.write(str(current_x) + ' ' + str(current_y) + '\n \n')
        if (abs(dx) < ok_zone) and (abs(dy) < ok_zone):
            complete += 1
            if complete < len(route):
                desired_x = route[complete][0]
                desired_y = route[complete][1]
finally:
    mA.stop(stop_action='brake')
    mB.stop(stop_action='brake')
    fh.close
