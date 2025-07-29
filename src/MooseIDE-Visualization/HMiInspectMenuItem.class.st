Class {
	#name : 'HMiInspectMenuItem',
	#superclass : 'HAbstractMenuItem',
	#category : 'MooseIDE-Visualization-Helpers',
	#package : 'MooseIDE-Visualization',
	#tag : 'Helpers'
}

{ #category : 'accessing' }
HMiInspectMenuItem >> canBeExecuted [

	^ shape isShape
]

{ #category : 'accessing' }
HMiInspectMenuItem >> description [

	^ 'Inspect the entity in Moose'
]

{ #category : 'execution' }
HMiInspectMenuItem >> execute [
	shape miInspect
]

{ #category : 'accessing' }
HMiInspectMenuItem >> group [

	^ 100
]

{ #category : 'accessing' }
HMiInspectMenuItem >> iconName [
	^ #smallInspectIt
]

{ #category : 'accessing' }
HMiInspectMenuItem >> label [
	^ 'Inspect'
]

{ #category : 'accessing' }
HMiInspectMenuItem >> order [
	^ 100
]
