"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MiAbstractDependencyBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'MooseIDE-Dependency-Dependency'
}

{ #category : #'world menu' }
MiAbstractDependencyBrowser class >> addToMiBrowsersMenu: aMenuPresenter [

	aMenuPresenter addItem: [ :item | 
		| subMenu |
		subMenu := SpMenuPresenter new.
		self subclassesDo: [ :browserClass | 
			browserClass addToMiBrowsersSubMenu: subMenu ].
		item
			name: 'Dependency';
			subMenu: subMenu ]
]

{ #category : #adding }
MiAbstractDependencyBrowser class >> addToMiBrowsersSubMenu: aMenuGroupPresenter [

	aMenuGroupPresenter addItem: [ :item | item name: self title ]
]

{ #category : #testing }
MiAbstractDependencyBrowser class >> isAbstract [ 
	^ self == MiAbstractDependencyBrowser
]

{ #category : #'world menu' }
MiAbstractDependencyBrowser class >> localMenuGroupIn: aMenuPresenter [

	^ aMenuPresenter menuGroups detect: [ :group | 
		  group label = 'Dependency' ]
]

{ #category : #'world menu' }
MiAbstractDependencyBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: self toolbarDependencyName)
		parent: (self midasBrowserMenuLabel) ;
		order: 30 ;
		label: 'Dependency'
]

{ #category : #'world menu' }
MiAbstractDependencyBrowser class >> toolbarDependencyName [
	^ 'MooseIDEDependencyBrowser'
]
