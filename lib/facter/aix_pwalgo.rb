#
#  FACT(S):     aix_pwalgo
#
#  PURPOSE:     This custom fact returns a simple string with the current, 
#		default, password hashing algorithm for this AIX system.
#
#  RETURNS:     (hash)
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        February 23, 2021
#
#  NOTES:       Myriad names and acronyms are trademarked or copyrighted by IBM
#               including but not limited to IBM, PowerHA, AIX, RSCT (Reliable,
#               Scalable Cluster Technology), and CAA (Cluster-Aware AIX).  All
#               rights to such names and acronyms belong with their owner.
#
#-------------------------------------------------------------------------------
#
#  LAST MOD:    (never)
#
#  MODIFICATION HISTORY:
#
#       (none)
#
#-------------------------------------------------------------------------------
#
Facter.add(:aix_pwalgo) do
    #  This only applies to the AIX operating system
    confine :osfamily => 'AIX'

    #  Define an unfortunate value for our default return
    l_aixPwdAlgo = 'default'

    #  Do the work
    setcode do
        #  Run the command to look through the process list for the Tidal daemon
        l_lines = Facter::Util::Resolution.exec('/usr/bin/lssec -f /etc/security/login.cfg -s usw -a pwd_algorithm 2>/dev/null')

        #  Loop over the lines that were returned
        l_lines && l_lines.split('\n').each do |l_oneLine|
            #  Strip leading and trailing whitespace and split on an equals sign
            l_list = l_oneLine.strip().split('=')

            #  If the first part matches, look at the second part
            if (l_list[0] == 'usw pwd_algorithm')
                #  If the second part is non-empty, copy it in
                if ((l_list[1].nil? == false) and (l_list[1] != ''))
                    l_aixPwdAlgo=l_list[1]
                end
            end
        end

        #  Implicitly return the contents of the variable
        l_aixPwdAlgo
    end
end
