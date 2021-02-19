function values = mvpalab_reorganize_(cfg,metric,metric_)
mvccdirections = exist('metric_','var');
    for sub = 1 : size(metric,1)
        for tp = 1 : size(metric,2)
            for freq = 1 : size(metric,3)
                temp = metric{sub,tp,freq};
                if mvccdirections
                    temp_ = metric_;
                end
                if cfg.classmodel.tempgen
                    for tp_ = 1 : length(temp)
                        if mvccdirections
                            values.ab{tp,tp_,sub,freq} = temp{tp_};
                            values.ba{tp,tp_,sub,freq} = temp_{tp_};
                        else
                            values{tp,tp_,sub,freq} = temp{tp_};
                        end
                    end
                else
                    if mvccdirections
                        values.ab{1,tp,sub,freq} = temp;
                        values.ba{1,tp,sub,freq} = temp_;
                    else
                        values{1,tp,sub,freq} = temp;
                    end
                end

            end
        end
    end
end