"
TODO
"
Class {
	#name : #MiCoOneGroupMarkStrategy,
	#superclass : #MiCoMarkStrategy,
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #hooks }
MiCoOneGroupMarkStrategy >> computeTag [
	^ groupsByTag size = 1
		ifTrue: [ groupsByTag keys anyOne ]
		ifFalse: [ nil ]
]

{ #category : #hooks }
MiCoOneGroupMarkStrategy >> order [
	^ 0
]
