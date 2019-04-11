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

sim_time = 30
sim_period = 0.01
sim_buffer = sim_time/sim_period

global complete
complete = 1
route = [0.4, 0.4; -0.4, 0.4; -1, -0.4; 0.4, -0.4; 0.4, 0.4]
importXcosDiagram("/home/aleksandr/ITMO_lab2/ev3/scilab/model3.zcos");
xcos_simulate(scs_m,4);
res = read("/home/aleksandr/ITMO_lab2/ev3/data/sqr1.txt", -1, 4)
x = res(:, 1)
y = res(:, 2)
xtitle('', 'X, м', 'Y, м')
xgrid(0)
plot2d(0,0,0,'031',' ',[-0.5,-0.5,0.5,0.5]);
plot2d(x, y, 2)
plot2d(X.values, Y.values, 5)
d = 0.1
for i = 1:length(route)/2
    xarc(route(i,1)-d/2, route(i,2)+d/2,d, d, 0, 360*64)
end
xs2png(0, "/home/aleksandr/ITMO_lab2/ev3/photos/graph2102-7.png")
