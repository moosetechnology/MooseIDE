"
This rule is a resource for tests.
It implements the small API needed of Rules to work with FamixCBRunner.
"
Class {
	#name : #FamixCBTestRule,
	#superclass : #Object,
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #accessing }
FamixCBTestRule >> condition [

	^ FamixCBCondition new
		  name: 'isAbstract condition';
		  query: (FamixCBQueryHandler on:
					   (FQSelectScriptQuery script: [ :entity | entity isAbstract ]))
]

{ #category : #accessing }
FamixCBTestRule >> context [

	^ FamixCBContext new
		  name: 'classes context';
		  contextFilter: [ :col | col select: #isClass ]
]
