function o = mvpalab_reorganize(cfg,metric,metric_)

% Class names:
id_1 = cfg.study.conditionIdentifier{1,1};
id_2 = cfg.study.conditionIdentifier{1,2};
id_3 = cfg.study.conditionIdentifier{2,1};
id_4 = cfg.study.conditionIdentifier{2,2};

mvcc = exist('metric_','var');

for sub = 1 : size(metric,1)
    for tp = 1 : size(metric,2)
        for freq = 1 : size(metric,3)
            % Result file or permaps
            if length(size(metric)) == 3
                
                temp = metric{sub,tp,freq};
                
                if mvcc
                    temp_ = metric_{sub,tp,freq};
                end
                
                % Temporal generalization or time resolved:
                if cfg.classmodel.tempgen
                    for tp_ = 1 : length(temp)
                        % MVPA or MVCC
                        if mvcc
                            
                            % MVCC - Direction A - B
                            o.(id_1)(tp,tp_,sub,freq) = temp_{tp_}(1);
                            o.(id_2)(tp,tp_,sub,freq) = temp_{tp_}(2);
                            
                            % MVCC - Direction B - A
                            o.(id_3)(tp,tp_,sub,freq) = temp{tp_}(1);
                            o.(id_4)(tp,tp_,sub,freq) = temp{tp_}(2);
                            
                        else
                            
                            % MVPA
                            o.(id_1)(tp,tp_,sub,freq) = temp{tp_}(1);
                            o.(id_2)(tp,tp_,sub,freq) = temp{tp_}(2);
                            o.mean(tp,tp_,sub,freq) = mean(temp{tp_});
                            
                        end
                    end
                else
                    % MVPA or MVCC
                    if mvcc
                        
                        % MVCC - Direction A - B
                        o.(id_1)(1,tp,sub,freq) = temp_(1);
                        o.(id_2)(1,tp,sub,freq) = temp_(2);
                        
                        % MVCC - Direction B - A
                        o.(id_3)(1,tp,sub,freq) = temp(1);
                        o.(id_4)(1,tp,sub,freq) = temp(2);
                        
                    else
                        
                        % MVPA
                        o.(id_1)(1,tp,sub,freq) = temp(1);
                        o.(id_2)(1,tp,sub,freq) = temp(2);
                        o.mean(1,tp,sub,freq) = mean(temp);
                        
                    end
                end
            else
                for per = 1 : size(metric,4)
                    temp = metric{sub,tp,freq,per};
                    
                    if mvcc
                        temp_ = metric_{sub,tp,freq,per};
                    end
                    
                    % Temporal generalization or time resolved:
                    if cfg.classmodel.tempgen
                        for tp_ = 1 : length(temp)
                            
                            % MVPA or MVCC
                            if mvcc
                                
                                % MVCC - Direction A - B
                                o.(id_1)(tp,tp_,sub,per,freq) = temp_{tp_}(1);
                                o.(id_2)(tp,tp_,sub,per,freq) = temp_{tp_}(2);
                                
                                % MVCC - Direction B - A
                                o.(id_3)(tp,tp_,sub,per,freq) = temp{tp_}(1);
                                o.(id_4)(tp,tp_,sub,per,freq) = temp{tp_}(2);
                                
                            else
                                
                                % MVPA
                                o.(id_1)(tp,tp_,sub,per,freq) = temp{tp_}(1);
                                o.(id_2)(tp,tp_,sub,per,freq) = temp{tp_}(2);
                                o.mean(tp,tp_,sub,per,freq) = mean(temp{tp_});
                                
                            end
                        end
                    else
                        % MVPA or MVCC
                        if mvcc
                            
                            % MVCC - Direction A - B
                            o.(id_1)(1,tp,sub,per,freq) = temp_(1);
                            o.(id_2)(1,tp,sub,per,freq) = temp_(2);
                            
                            % MVCC - Direction B - A
                            o.(id_3)(1,tp,sub,per,freq) = temp(1);
                            o.(id_4)(1,tp,sub,per,freq) = temp(2);
                            
                        else
                            
                            % MVPA
                            o.(id_1)(1,tp,sub,per,freq) = temp(1);
                            o.(id_2)(1,tp,sub,per,freq) = temp(2);
                            o.mean(1,tp,sub,per,freq) = mean(temp);
                            
                        end
                    end
                end
            end
        end
    end
end
end
