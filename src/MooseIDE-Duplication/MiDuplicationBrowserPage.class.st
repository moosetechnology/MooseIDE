Class {
	#name : #MiDuplicationBrowserPage,
	#superclass : #SpNotebookPage,
	#instVars : [
		'replica'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #'instance creation' }
MiDuplicationBrowserPage class >> forReplica: aReplica [

	^self new
		replica: aReplica ;
		yourself
		
]

{ #category : #initialization }
MiDuplicationBrowserPage >> initialize [

	super initialize.

	self beCloseable.
	self presenterProvider: [ SpTextPresenter new
		text: self textContent ]
]

{ #category : #accessing }
MiDuplicationBrowserPage >> replica: aReplica [
	replica := aReplica.
	self title: aReplica entity name.

]

{ #category : #accessing }
MiDuplicationBrowserPage >> textContent [
	^replica ifNil: [ '' ] ifNotNil: [ replica entity sourceText ]
]
