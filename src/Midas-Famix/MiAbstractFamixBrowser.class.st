Class {
	#name : #MiAbstractFamixBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'Midas-Famix-Browser'
}

{ #category : #'as yet unclassified' }
MiAbstractFamixBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #MidasFamixBrowser)
		parent: self toolbarName;
		label: 'Famix'
]

{ #category : #'as yet unclassified' }
MiAbstractFamixBrowser class >> toolbarFamixName [
	^ 'MidasFamixBrowser'
]
