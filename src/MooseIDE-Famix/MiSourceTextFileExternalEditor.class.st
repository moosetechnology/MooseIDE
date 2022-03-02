Class {
	#name : #MiSourceTextFileExternalEditor,
	#superclass : #MiSourceTextExternalEditor,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #protocol }
MiSourceTextFileExternalEditor >> open: aMooseEntity [
	((aMooseEntity  usesFamixTrait: FamixTSourceEntity)
	and: [ aMooseEntity sourceAnchor isFileAnchor ])
	ifTrue: [ self openFile: aMooseEntity sourceAnchor fileReference ]
]

{ #category : #protocol }
MiSourceTextFileExternalEditor >> openFile: aFilereference [
	self subclassResponsibility 

]
