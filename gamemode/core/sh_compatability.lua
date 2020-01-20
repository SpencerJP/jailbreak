--ExclServer support
if ES and CLIENT then
    hook.Add("ESSupressCustomVoice", "JB.SupressESVoice", function() return true end)
end