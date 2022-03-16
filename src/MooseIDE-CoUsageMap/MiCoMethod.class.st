"
Model for methods
"
Class {
	#name : #MiCoMethod,
	#superclass : #MiCoTaggedObject,
	#instVars : [
		'usedAttributes'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #adding }
MiCoMethod >> addAttribute: aMiCoAttribute [
	usedAttributes add: aMiCoAttribute
]

{ #category : #accessing }
MiCoMethod >> children [
	^ usedAttributes 
]

{ #category : #'building - menus' }
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

{ #category : #'building - menus' }
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

{ #category : #initialization }
MiCoMethod >> initialize [
	super initialize.
	usedAttributes := OrderedCollection new: 5.
]

{ #category : #accessing }
MiCoMethod >> usedAttributes [
	^ usedAttributes
]

{ #category : #accessing }
MiCoMethod >> usedAttributes: aCollection [
	usedAttributes := aCollection
]
