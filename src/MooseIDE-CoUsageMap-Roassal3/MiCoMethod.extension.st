Extension { #name : #MiCoMethod }

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoMethod >> conflictTagSubMenuWith: aMiCoMarkManager [
	| subMenu conflictTag |
	subMenu := MenuMorph new.
	
	conflictTag := aMiCoMarkManager conflictTag.
	self tag = conflictTag
		ifTrue: [ ^ subMenu ].
	(subMenu 
			add: 'Mark as conflict: ', conflictTag name
				target: aMiCoMarkManager
				selector: #setTag:onAttribute:
				argumentList: { conflictTag. self })
			icon: (aMiCoMarkManager iconFormFor: conflictTag).
	subMenu addLine.
	^ subMenu
]

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoMethod >> createMenuOn: aMenuMorph markManager: aMiCoMarkManager [
	| subMenu |	
	subMenu := aMiCoMarkManager 
		subMenuTagsFor: self 
		subMenu: (self conflictTagSubMenuWith: aMiCoMarkManager).
	
	aMenuMorph
		addTitle: 'Method: <', (aMiCoMarkManager contractLabel: self name),'>';
		add: 'Tags' 
			subMenu: subMenu;
		add: 'Inspect'
			target: self rawObject
			selector: #inspect
			argument: #()
]
