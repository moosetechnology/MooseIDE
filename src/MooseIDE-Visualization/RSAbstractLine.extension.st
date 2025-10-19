Extension { #name : 'RSAbstractLine' }

{ #category : '*MooseIDE-Visualization' }
RSAbstractLine >> miInspect [

	| list |

	list := self model.

	list ifEmpty: [ self error: '' ].

	(list size = 1
		 ifTrue: [ list anyOne ]
		 ifFalse: [ list ]) miInspect
]

{ #category : '*MooseIDE-Visualization' }
RSAbstractLine >> miPropagateOn: buses [

	| list |
	"This should send #miInspect to the model but that means the model should be a HLink and for now it is not."
	list := self from model allRawModelDependenciesIn: self to model.

	list ifEmpty: [ self error: '' ].

	(list size = 1
		 ifTrue: [ list first ]
		 ifFalse: [ list ]) miPropagateOn: buses
]
