"
Generates a statistical report on key features of a Moose model
The report is generated in markdown and can be edited manually before being exported

Accepted entities: A mooseModel
"
Class {
	#name : #MiModelReporter,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter'
	],
	#category : #'MooseIDE-Core-Reporter'
}

{ #category : #'world menu' }
MiModelReporter class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiModelReporter class >> menuItem [

	^#ModelReporter
]

{ #category : #'world menu' }
MiModelReporter class >> menuPriority [

	^ self menuMetaToolsPriority + 1
]

{ #category : #'world menu' }
MiModelReporter class >> newModel [

	^ MiModelReporterModel new
]

{ #category : #'world menu' }
MiModelReporter class >> open [
	<script>
	^ super open
]

{ #category : #'world menu' }
MiModelReporter class >> title [
	^ 'Model Reporter'
]

{ #category : #testing }
MiModelReporter >> canFollowEntity: anObject [

	^anObject isMooseModel 
]

{ #category : #testing }
MiModelReporter >> canPropagate [

	^ false
]

{ #category : #testing }
MiModelReporter >> canTagEntities [

	^ false
]

{ #category : #testing }
MiModelReporter >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel followEntity: anEntity
]

{ #category : #testing }
MiModelReporter >> initializePresenters [

	mainPresenter := self newText
]

{ #category : #testing }
MiModelReporter >> miSelectedItem [

	^#()
]

{ #category : #actions }
MiModelReporter >> updateReport: report [

	mainPresenter text: report
]
