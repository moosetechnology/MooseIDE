Class {
	#name : #MiExportAbstractColumnModel,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'MooseIDE-Export-Browser'
}

{ #category : #testing }
MiExportAbstractColumnModel class >> isAbstract [
	
	^self  == MiExportAbstractColumnModel
]

{ #category : #api }
MiExportAbstractColumnModel >> exportValueFor: anEntity [
	^ self printValueFor: anEntity
]

{ #category : #testing }
MiExportAbstractColumnModel >> isPropertyColumn [

	^ false
]

{ #category : #testing }
MiExportAbstractColumnModel >> isQueryColumn [

	^ false
]

{ #category : #accessing }
MiExportAbstractColumnModel >> name [

	^ name
]

{ #category : #accessing }
MiExportAbstractColumnModel >> name: anObject [

	name := anObject
]

{ #category : #api }
MiExportAbstractColumnModel >> printValueFor: anEntity [

	^ [ self privatePrintValueFor: anEntity ]
		  on: Exception
		  do: [ 'error' ]
]

{ #category : #private }
MiExportAbstractColumnModel >> privatePrintValueFor: anEntity [
	self subclassResponsibility
]
