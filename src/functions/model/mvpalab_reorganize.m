function values = mvpalab_reorganize(cfg,metric,metric_)
mvccdirections = exist('metric_','var');
for sub = 1 : size(metric,1)
    for tp = 1 : size(metric,2)
        for freq = 1 : size(metric,3)
            % Result file or permaps
            if length(size(metric)) == 3
                
                temp = metric{sub,tp,freq};
                
                if mvccdirections
                    temp_ = metric_{sub,tp,freq};
                end
                
                % Temporal generalization or time resolved:
                if cfg.classmodel.tempgen
                    for tp_ = 1 : length(temp)
                        % MVPA or MVCC
                        if mvccdirections
                            
                            % MVCC - Direction A - B
                            values.class_a.ab(tp,tp_,sub,freq) = temp{tp_}(1);
                            values.class_b.ab(tp,tp_,sub,freq) = temp{tp_}(2);
                            values.mean_model.ab(tp,tp_,sub,freq) = mean(temp{tp_});
                            
                            % MVCC - Direction B - A
                            values.class_a.ba(tp,tp_,sub,freq) = temp_{tp_}(1);
                            values.class_b.ba(tp,tp_,sub,freq) = temp_{tp_}(2);
                            values.mean_model.ba(tp,tp_,sub,freq) = mean(temp_{tp_});
                            
                        else
                            
                            % MVPA
                            values.class_a(tp,tp_,sub,freq) = temp{tp_}(1);
                            values.class_b(tp,tp_,sub,freq) = temp{tp_}(2);
                            values.mean_model(tp,tp_,sub,freq) = mean(temp{tp_});
                            
                        end
                    end
                else
                    % MVPA or MVCC
                    if mvccdirections
                        
                        % MVCC - Direction A - B
                        values.class_a.ab(1,tp,sub,freq) = temp(1);
                        values.class_b.ab(1,tp,sub,freq) = temp(2);
                        values.mean_model.ab(1,tp,sub,freq) = mean(temp);
                        
                        % MVCC - Direction B - A
                        values.class_a.ba(1,tp,sub,freq) = temp_(1);
                        values.class_b.ba(1,tp,sub,freq) = temp_(2);
                        values.mean_model.ba(1,tp,sub,freq) = mean(temp_);
                        
                    else
                        
                        % MVPA
                        values.class_a(1,tp,sub,freq) = temp(1);
                        values.class_b(1,tp,sub,freq) = temp(2);
                        values.mean_model(1,tp,sub,freq) = mean(temp);
                        
                    end
                end
            else
                for per = 1 : size(metric,4)
                    temp = metric{sub,tp,freq,per};
                    
                    if mvccdirections
                        temp_ = metric_{sub,tp,freq,per};
                    end
                    
                    % Temporal generalization or time resolved:
                    if cfg.classmodel.tempgen
                        for tp_ = 1 : length(temp)
                            
                            % MVPA or MVCC
                            if mvccdirections
                                
                                % MVCC - Direction A - B
                                values.class_a.ab(tp,tp_,sub,per,freq) = temp{tp_}(1);
                                values.class_b.ab(tp,tp_,sub,per,freq) = temp{tp_}(2);
                                values.mean_model.ab(tp,tp_,sub,per,freq) = mean(temp{tp_});
                                
                                % MVCC - Direction B - A
                                values.class_a.ba(tp,tp_,sub,per,freq) = temp_{tp_}(1);
                                values.class_b.ba(tp,tp_,sub,per,freq) = temp_{tp_}(2);
                                values.mean_model.ba(tp,tp_,sub,per,freq) = mean(temp_{tp_});
                                
                            else
                                
                                % MVPA
                                values.class_a(tp,tp_,sub,per,freq) = temp{tp_}(1);
                                values.class_b(tp,tp_,sub,per,freq) = temp{tp_}(2);
                                values.mean_model(tp,tp_,sub,per,freq) = mean(temp{tp_});
                                
                            end
                        end
                    else
                        % MVPA or MVCC
                            if mvccdirections
                                
                                % MVCC - Direction A - B
                                values.class_a.ab(1,tp,sub,per,freq) = temp(1);
                                values.class_b.ab(1,tp,sub,per,freq) = temp(2);
                                values.mean_model.ab(1,tp,sub,per,freq) = mean(temp);
                                
                                % MVCC - Direction B - A
                                values.class_a.ba(1,tp,sub,per,freq) = temp_(1);
                                values.class_b.ba(1,tp,sub,per,freq) = temp_(2);
                                values.mean_model.ba(1,tp,sub,per,freq) = mean(temp_);
                                
                            else
                                
                                % MVPA
                                values.class_a(1,tp,sub,per,freq) = temp(1);
                                values.class_b(1,tp,sub,per,freq) = temp(2);
                                values.mean_model(1,tp,sub,per,freq) = mean(temp);
                        
                            end
                    end
                end
            end
        end
    end
end
end
