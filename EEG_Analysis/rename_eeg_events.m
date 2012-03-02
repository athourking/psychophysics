for event = 1: length(EEG.event)
    foo = dec2bin(EEG.event(event).type, 16);
    EEG.event(event).type_2 = bin2dec( foo(end-7:end) );
end