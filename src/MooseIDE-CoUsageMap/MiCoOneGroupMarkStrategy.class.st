"
If there is only one box in the container, container will take the inner box tag
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
