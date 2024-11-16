Class {
	#name : #MiAnalysisPropagateLocallyCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Analysis'
}

{ #category : #default }
MiAnalysisPropagateLocallyCommand class >> defaultDescription [

	^ 'Propagate to the next browser in the list'
]

{ #category : #default }
MiAnalysisPropagateLocallyCommand class >> defaultIconName [

	^ #mooseOutgoing
]

{ #category : #default }
MiAnalysisPropagateLocallyCommand class >> defaultName [

	^ 'Propagate locally'
]

{ #category : #executing }
MiAnalysisPropagateLocallyCommand >> execute [

	self context propagateLocally
]
