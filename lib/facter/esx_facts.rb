facts = ["esx_Host_Name", "esx_Host_Manufacturer", "esx_Host_Model", "esx_Host_Version", "esx_Host_Build", "esx_Host_Cluster"]
facts.each {|i|
  key = i.downcase
  Facter.add("ecg_#{key}") do
  if Facter.value(:kernel).downcase == "windows"
    setcode do
      if Facter::Core::Execution.which('vmtoolsd')
        Facter::Util::Resolution.exec(%Q{cmd /c ""C:\\Program Files\\VMware\\VMware Tools\\vmtoolsd" --cmd "info-get guestinfo.#{i}"})
      end
    end
  end
  if Facter.value(:kernel).downcase == "linux"
    setcode do
      if Facter::Core::Execution.which('vmtoolsd')
        Facter::Core::Execution.execute("vmtoolsd --cmd 'info-get guestinfo.#{i}' 2>&1")
      end
	end
  end
end
}
