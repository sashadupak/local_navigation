clear();
//close();
//clc();

ke = 0.5
km = 0.5
R = 6.1
J = 0.0025
L = 0.0047

Moth = 0
r = 0.02 //радиус колеса
B = 0.12 //расстояние между колесами

k1 = 8
k2 = 0.5
k3 = 0.06
zone = 0.05
voltage = 7.00

sim_time = 10
sim_period = 0.01
sim_buffer = sim_time/sim_period
d_min = 0.35

global complete
global dist dist1 dist2
dist1 = 255
dist2 = 255
complete = 1
route = [1, 1]
line = [0, 1; 1, 0]
lineA = line(2, 2) - line(1, 2)
lineB = line(1, 1) - line(2, 1)
lineC = -line(1, 1)*line(2, 2) + line(1, 1)*line(1, 2) + line(1, 2)*line(2, 1) - line(1, 2)*line(1, 1)
line_ang = atan((line(2, 2)-line(1, 2))/(line(2, 1)-line(1, 1)))
importXcosDiagram("/home/aleksandr/ITMO_lab2/ev3/scilab/model4.zcos");
xcos_simulate(scs_m,4);
res = read("/home/aleksandr/ITMO_lab2/ev3/data/wall.txt", -1, 4)
x = res(:, 1)
y = res(:, 2)
xtitle('', 'X, м', 'Y, м')
xgrid(0)
plot2d(0,0,0,'031',' ',[-1.2,-1.2,1.2,1.2]);
//plot line
plot2d(x, y, 2)
plot2d(X.values, Y.values, 5)
d = 0.1
for i = 1:length(route)/2
    xarc(route(i,1)-d/2, route(i,2)+d/2,d, d, 0, 360*64)
end
xs2png(0, "/home/aleksandr/ITMO_lab2/ev3/photos/graph1802.png")
