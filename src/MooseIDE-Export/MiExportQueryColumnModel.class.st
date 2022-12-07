Class {
	#name : #MiExportQueryColumnModel,
	#superclass : #MiExportAbstractColumnModel,
	#instVars : [
		'query'
	],
	#category : #'MooseIDE-Export-Browser'
}

{ #category : #testing }
MiExportQueryColumnModel >> isQueryColumn [

	^ true
]

{ #category : #accessing }
MiExportQueryColumnModel >> privatePrintValueFor: anEntity [
	^ query value: anEntity
]

{ #category : #accessing }
MiExportQueryColumnModel >> query [

	^ query
]

{ #category : #accessing }
MiExportQueryColumnModel >> query: anObject [

	query := anObject
]
