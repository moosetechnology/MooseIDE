Class {
	#name : #MiAbstractFamixBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'MooseIDE-Famix-Browser'
}

{ #category : #adding }
MiAbstractFamixBrowser class >> addItemOrSubMenuToMiBrowsersMenu: aMenuPresenter [

	aMenuPresenter addItem: [ :item | 
		| subMenu |
		subMenu := SpMenuPresenter new.
		self subclassesDo: [ :browserClass | 
			browserClass addToMiBrowsersMenu: subMenu ].
		item
			name: self subMenuLabel;
			subMenu: subMenu ]
]

{ #category : #testing }
MiAbstractFamixBrowser class >> isAbstract [ 
	^ self == MiAbstractFamixBrowser 
]

{ #category : #'world menu' }
MiAbstractFamixBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #MooseIDEFamixBrowser)
		parent: self midasBrowserMenuLabel;
		order: 40;
		label: self subMenuLabel
]

{ #category : #'world menu' }
MiAbstractFamixBrowser class >> subMenuLabel [

	^ 'Famix'
]

{ #category : #'world menu' }
MiAbstractFamixBrowser class >> toolbarFamixName [
	^ 'MooseIDEFamixBrowser'
]
