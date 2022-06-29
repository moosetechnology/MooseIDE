Class {
	#name : #FamixCBContext,
	#superclass : #FamixCBEntity,
	#traits : 'FamixCBTRuleComponent',
	#classTraits : 'FamixCBTRuleComponent classTrait',
	#instVars : [
		'#children => FMMany type: #FamixCBTRuleComponent opposite: #parent',
		'#contextBlock => FMProperty',
		'#entities => FMProperty'
	],
	#category : #'Famix-CriticBrowser-Entities-Entities'
}

{ #category : #meta }
FamixCBContext class >> annotation [

	<FMClass: #Context super: #FamixCBEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^self
]

{ #category : #'instance creation' }
FamixCBContext class >> named: aString on: anObject summary: aSummary [
	^ self new
		name: aString;
		contextBlock: anObject;
		summary: aSummary;
		yourself
]

{ #category : #adding }
FamixCBContext >> addChild: anObject [
	^ self children add: anObject
]

{ #category : #adding }
FamixCBContext >> addEntity: anObject [
	<generated>
	^ self entities add: anObject
]

{ #category : #accessing }
FamixCBContext >> children [
	"Relation named: #children type: #FamixCBTRuleComponent opposite: #parent"

	<generated>
	<FMComment: 'Every child context or condition of this context.'>
	<derived>
	^ children
]

{ #category : #accessing }
FamixCBContext >> children: anObject [

	<generated>
	children value: anObject
]

{ #category : #accessing }
FamixCBContext >> contextBlock [

	<FMProperty: #contextBlock type: #Object>
	<generated>
	<FMComment: 'Block to execute to get the context''s entities'>
	^ contextBlock
]

{ #category : #accessing }
FamixCBContext >> contextBlock: anObject [

	contextBlock := Smalltalk compiler evaluate: anObject
]

{ #category : #accessing }
FamixCBContext >> entities [

	<FMProperty: #entities type: #Object>
	<generated>
	<FMComment: 'Entities matching the context'>
	^ entities
]

{ #category : #accessing }
FamixCBContext >> entities: anObject [
	<generated>
	entities := anObject
]

{ #category : #running }
FamixCBContext >> runOn: aCollection [

	entities := (contextBlock value: aCollection).
	children do: [ :c | c runOn: entities ] 
]
