//read data
res = read("/home/aleksandr/Arduino/data/imu.txt", -1, 6)
gyro_speed = res(:, 1:3)
accel_raw = res(:, 1:3)
t = 1:length(gyro_raw(:, 1))
//time interval
dt = 0.05
//integrate gyro rate
gyro_angle = zeros(gyro_speed)
for i = 2:length(t)
    gyro_angle(i, :) = gyro_angle(i-1, :) + gyro_speed(i, :) * dt
end

accel_result = sqrt(accel_raw(:, 1).^2 + accel_raw(:, 2).^2 + accel_raw(:, 3).^2)
hp_accel_result = high_pass_filter(accel_result, 0.75)

//plot graph
//plot2d(t, gyro_raw(:, 1), 2)
plot2d(t, hp_accel_result)

function hp = high_pass_filter(in, kf)
    hp = zeros(in)
    for i = 2:length(in)
        hp(i) = (1 - kf)*hp(i) + (1 - kf)*(in(i) - in(i-1))
    end
endfunction
//function low_pass_filter()
    //KF = 0.98
//low_pass = zeros(gyro_angle(:, 1));
//for i = 2:length(t)
//    low_pass(i) = (1 - KF)*accel_angle(i) + KF*low_pass(i-1);
//end
//endfunction
