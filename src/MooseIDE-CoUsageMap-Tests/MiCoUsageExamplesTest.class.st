Class {
	#name : #MiCoUsageExamplesTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #tests }
MiCoUsageExamplesTest >> testAllExamples [

	| inst errors |
	#MiCoUsageExamplesTest traceCr.
	inst := MiCoUsageMapExamples new.
	errors := inst class methods select: [ :each | 
		(each selector beginsWith: 'example') and: [ 
			[ inst perform: each selector. false ]
			onErrorDo:[ :ex | true ] ] ].
	self assert: errors isEmpty description: 'should run without errors'
]
