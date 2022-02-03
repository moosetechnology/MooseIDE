"
TODO
"
Class {
	#name : #MiCoMarkStrategy,
	#superclass : #Object,
	#instVars : [
		'method',
		'groupsByTag'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #hooks }
MiCoMarkStrategy >> computeTag [
	"retuns a tag for the method"
	^ self subclassResponsibility
]

{ #category : #accessing }
MiCoMarkStrategy >> groupsByTag [

	^ groupsByTag
]

{ #category : #accessing }
MiCoMarkStrategy >> groupsByTag: aDictionary [
	groupsByTag := aDictionary
]

{ #category : #accessing }
MiCoMarkStrategy >> method [

	^ method
]

{ #category : #accessing }
MiCoMarkStrategy >> method: aMiCoMethod [
	method := aMiCoMethod
]

{ #category : #hooks }
MiCoMarkStrategy >> order [
	"a number"
	^ self subclassResponsibility
]
