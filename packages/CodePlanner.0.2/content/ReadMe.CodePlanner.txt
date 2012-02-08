NOTE: This is 0.2 and I´m still playing around... 
But my intentions is to do something serious with this.

1. Create you DomainModel in the Model folder of the CORE project, at the end of this file is a simple example of two classes realting to each other.

2. Compile

3. Open the Package Manager Console.

4. Scaffold your system by writing "Scaffold CodePlanner.ScaffoldAll"

5. Hit F5 to run your new system with jQueryMobile

Remember:
- Add DisplayColumn attribute on your entities. Or else you will get a scaffolding error.

News:
- Added jQueryMobile as default GUI
- Added methods for paging (with sorting)
- Added methods for find (with sorting)
- Added Home/Index with all scaffolded entities as startpage

Known Issues:
- Force is not working when re-scaffolding. Work around is to delete the files you want to re-scaffold.
- When re-scaffolding the scaffolder adds extra ninject registrations. Solution... Remove added lines!
- The scaffolder cant handle mantToMany relations in the views. Work around NONE. You have to write logic your self.
- Links will sometimes not work due to redirect from controllers and url will not be correct. Will be fixed when jquery/ajax communication is added.

//EXAMPLE DOMAIN MODEL
[Serializable]
    [DataContract]
    [DisplayColumn("Name")]
    public partial class Company : PersistentEntity
    {
        [DataMember]
        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        [DataMember]
        [Required]
        [MaxLength(50)]
        public string Location { get; set; }

        [DataMember]
        public virtual IList<Person> People { get; set; }
    }

    [Serializable]
    [DataContract]
    [DisplayColumn("Name")]
    public partial class Person : PersistentEntity
    {
        [DataMember]
        [MaxLength(50)]
        public string Name { get; set; }

        [DataMember]
        [MaxLength(200)]
        public string Information { get; set; }

        public int CompanyId { get; set; }
        [DataMember]
        [ForeignKey("CompanyId")]
        public virtual Company Company { get; set; }
    }