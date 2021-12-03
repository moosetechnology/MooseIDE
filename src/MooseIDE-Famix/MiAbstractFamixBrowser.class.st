Class {
	#name : #MiAbstractFamixBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'MooseIDE-Famix-Browser'
}

{ #category : #testing }
MiAbstractFamixBrowser class >> isAbstract [ 
	^ self == MiAbstractFamixBrowser 
]

{ #category : #'world menu' }
MiAbstractFamixBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #MooseIDEFamixBrowser)
		parent: (self midasBrowserMenuLabel) ;
		order: 40 ;
		label: 'Famix'
]

{ #category : #'world menu' }
MiAbstractFamixBrowser class >> toolbarFamixName [
	^ 'MooseIDEFamixBrowser'
]
