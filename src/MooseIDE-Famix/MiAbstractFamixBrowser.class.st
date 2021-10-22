Class {
	#name : #MiAbstractFamixBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'MooseIDE-Famix-Browser'
}

{ #category : #testing }
MiAbstractFamixBrowser class >> isAbstract [ 
	^ self == MiAbstractFamixBrowser 
]

{ #category : #'as yet unclassified' }
MiAbstractFamixBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #MooseIDEFamixBrowser)
		parent: (self midasBrowserMenuLabel) ;
		order: 40 ;
		label: 'Famix'
]

{ #category : #'as yet unclassified' }
MiAbstractFamixBrowser class >> toolbarFamixName [
	^ 'MooseIDEFamixBrowser'
]
