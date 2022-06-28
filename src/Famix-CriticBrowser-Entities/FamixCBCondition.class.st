Class {
	#name : #FamixCBCondition,
	#superclass : #FamixCBEntity,
	#traits : 'FamixCBTRuleComponent',
	#classTraits : 'FamixCBTRuleComponent classTrait',
	#instVars : [
		'#query => FMProperty',
		'#violations => FMMany type: #FamixCBViolation opposite: #violatedRule'
	],
	#category : #'Famix-CriticBrowser-Entities-Entities'
}

{ #category : #meta }
FamixCBCondition class >> annotation [

	<FMClass: #Condition super: #FamixCBEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^self
]

{ #category : #'instance creation' }
FamixCBCondition class >> named: aString on: aQuery [
	^ self new
		name: aString;
		query: aQuery;
		yourself
]

{ #category : #adding }
FamixCBCondition >> addViolation: anObject [
	<generated>
	^ self violations add: anObject
]

{ #category : #accessing }
FamixCBCondition >> query [

	<FMProperty: #query type: #Object>
	<generated>
	<FMComment: 'Block to execute to find violations to the condition within the parent context'>
	^ query
]

{ #category : #accessing }
FamixCBCondition >> query: aQuery [

	(aQuery class inheritsFrom: MiCriticBrowserAbstractQuery) 
		ifTrue: [ query := aQuery ]
		ifFalse: [ self error: NotAValidQuery signal ]
]

{ #category : #running }
FamixCBCondition >> runOn: aCollection [
	^ ((self query runOnCollection: aCollection) collect: 
		[ :each | (FamixCBViolation rule: self violatedBy: each) ]) asMooseGroup specialize.
]

{ #category : #accessing }
FamixCBCondition >> violations [
	"Relation named: #violations type: #FamixCBViolation opposite: #violatedRule"

	<generated>
	<FMComment: 'Every violation of this condition.'>
	<derived>
	^ violations
]

{ #category : #accessing }
FamixCBCondition >> violations: anObject [

	<generated>
	violations value: anObject
]
