Class {
	#name : #MiCoUsageExamplesTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests'
}

{ #category : #tests }
MiCoUsageExamplesTest >> testAllExamples [

	| inst errors |
	inst := MiCoUsageMapExamples new.
	errors := inst class methods select: [ :arg1 | 
		        (arg1 selector beginsWith: 'example') and: [ 
			        [ 
			        inst perform: arg1 selector.
			        false ]
				        on: Error
				        do: [ :arg2 | true ] ] ].
	self assert: errors isEmpty description: 'should run without errors'
]
