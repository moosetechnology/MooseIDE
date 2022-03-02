Extension { #name : #MiCoAttribute }

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoAttribute >> createMenuOn: aMenuMorph markManager: aMiCoMarkManager [
	aMenuMorph
		addTitle: 'Var: <', (aMiCoMarkManager contractLabel: self name),'>';
		add: 'Tags' 
			subMenu: (aMiCoMarkManager subMenuTagsFor: self subMenu: MenuMorph new);
		add: 'Inspect'
			target: self rawObject
			selector: #inspect
			argument: #() 
]
