Class {
	#name : #MiAbstractFamixBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'Midas-Famix-Browser'
}

{ #category : #testing }
MiAbstractFamixBrowser class >> isAbstract [ 
	^ self == MiAbstractFamixBrowser 
]

{ #category : #'as yet unclassified' }
MiAbstractFamixBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #MidasFamixBrowser)
		parent: (self toolbarName) ;
		order: 40 ;
		label: 'Famix'
]

{ #category : #'as yet unclassified' }
MiAbstractFamixBrowser class >> toolbarFamixName [
	^ 'MidasFamixBrowser'
]
