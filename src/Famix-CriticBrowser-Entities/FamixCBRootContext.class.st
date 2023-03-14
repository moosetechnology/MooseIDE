Class {
	#name : #FamixCBRootContext,
	#superclass : #FamixCBContext,
	#category : #'Famix-CriticBrowser-Entities-Entities'
}

{ #category : #meta }
FamixCBRootContext class >> annotation [

	<FMClass: #RootContext super: #FamixCBContext>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
FamixCBRootContext >> getAllViolations [
	| res |
	res := Dictionary new.
	self putViolationsInto: res.
	^ res
	
]

{ #category : #removing }
FamixCBRootContext >> removeSelfFromTree [

	^ self
]

{ #category : #running }
FamixCBRootContext >> runOn: aCollection [

	self entities: aCollection
]

{ #category : #'as yet unclassified' }
FamixCBRootContext >> runUpTree: aCollection [
	^ aCollection
]

{ #category : #'ston persistence' }
FamixCBRootContext >> stonOn: stonWriter [
	self children do: [ :child | child stonOn: stonWriter ]
]
