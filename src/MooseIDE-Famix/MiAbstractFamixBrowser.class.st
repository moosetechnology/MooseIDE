Class {
	#name : #MiAbstractFamixBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'MooseIDE-Famix-Browser'
}

{ #category : #menu }
MiAbstractFamixBrowser class >> addItemOrSubMenuToMiBrowsersMenu: aRootMenu defaultSubMenu: aSubMenu [

	aSubMenu addItem: [ :item | 
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
		order: self menuPriority;
		label: self subMenuLabel
]

{ #category : #'world menu' }
MiAbstractFamixBrowser class >> menuPriority [

	^ 40
]

{ #category : #'world menu' }
MiAbstractFamixBrowser class >> subMenuLabel [

	^ 'Famix'
]

{ #category : #'world menu' }
MiAbstractFamixBrowser class >> toolbarFamixName [
	^ 'MooseIDEFamixBrowser'
]
