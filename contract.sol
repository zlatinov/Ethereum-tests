contract EthereumTraining {
    address internal creator;
    
    struct Profile {
        bool exists;
        uint8 age;
        string name;
        string specialty;
        string twitter_url;
        string github_url;
        string linkedin_url;
    }
    
    Profile[] internal profiles;
    
    mapping(address => uint) internal iterations;
    
    event profileCreated(uint profile_id);
    event profileUpdated(uint profile_id);

    function EthereumTraining() {
        creator = msg.sender;
    }
    
    modifier onlyCreator() { if (msg.sender != creator) throw; _ }
    modifier profileExists(uint profile_id) { if (profiles[profile_id].exists != true) throw; _ }
    modifier verifyProfileData(string name, uint8 age, string specialty) { if (bytes(name).length == 0 || age == 0 || bytes(specialty).length == 0) throw; _ }
    
    /// @dev name, age, specialty can't be empty. Only contract creator can create profiles. Function canIModifyProfiles() can be used to verify access.
    function createProfile(string name, uint8 age, string specialty, string twitter_url, string github_url, string linkedin_url)
        onlyCreator()
        verifyProfileData(name, age, specialty)
        
        returns (uint profile_id)
    {
        profiles.push(Profile({
            exists: true,
            age: age,
            name: name,
            specialty: specialty,
            twitter_url: twitter_url,
            github_url: github_url,
            linkedin_url: linkedin_url
            }));

        profile_id = profiles.length - 1;
        
        profileCreated(profile_id);
    }
    
    function getProfile(uint profile_id)
        profileExists(profile_id)
        
        returns (string name, uint8 age, string specialty, string twitter_url, string github_url, string linkedin_url)
    {
        Profile profile = profiles[profile_id];

        return (profile.name, profile.age, profile.specialty, profile.twitter_url, profile.github_url, profile.linkedin_url);
    }
    
    /// @dev name, age, specialty are can't be empty. Only contract creator can update profiles. Function canIModifyProfiles() can be used to verify access.
    function updateProfile(uint profile_id, string name, uint8 age, string specialty, string twitter_url, string github_url, string linkedin_url)
        onlyCreator()
        profileExists(profile_id)
        verifyProfileData(name, age, specialty)
        
        returns (bool)
    {
        profiles[profile_id].age = age;
        profiles[profile_id].name = name;
        profiles[profile_id].specialty = specialty;
        profiles[profile_id].twitter_url = twitter_url;
        profiles[profile_id].github_url = github_url;
        profiles[profile_id].linkedin_url = linkedin_url;
        
        profileUpdated(profile_id);
        
        return true;
    }
    
    function canIModifyProfiles()
        returns (bool)
    {
        return msg.sender == creator;
    }
    
    function hasNext()
        returns (bool)
    {
        return iterations[msg.sender] < profiles.length;
    }
    
    function next()
        returns (string name, uint8 age, string specialty, string twitter_url, string github_url, string linkedin_url)
    {
        if(hasNext()) {
            Profile profile = profiles[iterations[msg.sender]];
            
            iterations[msg.sender]++;
            
            return (profile.name, profile.age, profile.specialty, profile.twitter_url, profile.github_url, profile.linkedin_url);
        }
        else {
            throw;
        }
    }
    
    function rewind() {
        iterations[msg.sender] = 0;
    }
    
    // Don't want to accept Ether.
    function() { throw; }
}