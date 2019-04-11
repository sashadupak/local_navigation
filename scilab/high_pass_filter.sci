clear();
close();
//clc();

function hp = high_pass_filter(in, kf)
    hp = zeros(in)
    for i = 2:length(in)
        hp(i) = (1 - kf)*hp(i-1) + (1 - kf)*(in(i) - in(i-1))
    end
endfunction

function lp = low_pass_filter(in, kf)
    lp = zeros(in)
    for i = 2:length(in)
        lp(i) = (1 - kf)*in(i) + kf*lp(i-1);
    end
endfunction

res = read("/home/aleksandr/ITMO_lab2/ev3/oth/2102/gyro_data.txt", -1, 3)
pos = res(:, 1)
gyro = res(:, 2)
t = res(:, 3)
off = low_pass_filter(gyro, 0.99)
filt_gyro = high_pass_filter(gyro.*1.4-off, 0.005)

plot2d(t, pos, 2)
plot2d(t, gyro, 3)
plot2d(t, filt_gyro, 5)
plot2d(t, off, 4)
plot2d(t, gyro.*1.4-off, 6)
//legend('Position', 'Gyro data', 'Filt gyro data')
xtitle('', 'Time, s', 'Angle, deg')
//xs2png(0, "/home/aleksandr/ITMO_lab2/ev3/photos/gyro6.png")
