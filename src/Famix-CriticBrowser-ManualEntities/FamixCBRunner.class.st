"
I am used to run critics outside the critic browser.
I work with classes that have the following API:

`#context` should return a FamixCBContext
`#condition` should return a FamixCBContidion
"
Class {
	#name : 'FamixCBRunner',
	#superclass : 'Object',
	#instVars : [
		'rootContext'
	],
	#category : 'Famix-CriticBrowser-ManualEntities',
	#package : 'Famix-CriticBrowser-ManualEntities'
}

{ #category : 'adding' }
FamixCBRunner >> addRule: aRule [

	| context |
	context := aRule context.
	context addChild: aRule condition.
	rootContext addChild: context
]

{ #category : 'adding' }
FamixCBRunner >> addRules: aCollection [

	aCollection do: [ :rule | self addRule: rule ]
]

{ #category : 'initialization' }
FamixCBRunner >> initialize [

	super initialize.
	rootContext := FamixCBRootContext new
		               contextFilter: [ :col | col ];
		               yourself
]

{ #category : 'running' }
FamixCBRunner >> runOn: aMooseGroup [

	rootContext runDownTree: aMooseGroup withCallback: [ ].
	^ rootContext getAllViolations values flatten
]
