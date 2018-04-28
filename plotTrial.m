function y = plotTrial(pac0, pac1, pdc, spdot, myrange)
    figure(1);
    clf;
    subplot(2, 3, 1);
    plot(pac0);
    title("extracted pac0");
    subplot(2,3, 4);
    plot(pac1);
    title("extracted pac1");
    subplot(2,3,2);
    plot(pdc);
    title("full pdc");
    subplot(2,3,5);
    plot(spdot);
    title("full spdot");
    r1 = myrange{1};
    r2 = myrange{2};
    subplot(2,3,3);
    plot(pdc(r1:r2));
    title("extracted pdc");
    r1 = floor(r1/10);
    if (r1 < 1)
        r1 = 1;
    end
    r2 = floor(r2/10);
    subplot(2,3,6);
    plot(spdot(r1:r2));
    title("extracted spdot");