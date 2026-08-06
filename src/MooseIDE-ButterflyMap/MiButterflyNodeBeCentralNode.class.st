Class {
	#name : 'MiButterflyNodeBeCentralNode',
	#superclass : 'MiButterflyNodeMenuItem',
	#category : 'MooseIDE-ButterflyMap-Menu',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Menu'
}

{ #category : 'testing' }
MiButterflyNodeBeCentralNode >> canBeExecuted [
	"HMenuBuilder pre-filters items for group/separator purposes before #visualization: is
	 set (only set right before #buildOn: is sent, further down the same pipeline); answer
	 true when it isn't set yet so the item survives that pre-pass, since #buildOn: re-checks
	 #canBeExecuted itself once #visualization: is actually available and is authoritative
	 for whether the item is really shown."

	^ visualization isNil or: [
		  shape model rawModel ~= visualization centralNode rawModel ]
]

{ #category : 'execution' }
MiButterflyNodeBeCentralNode >> execute [

	visualization mapModel currentEntity: shape model rawModel.
	visualization mapModel browser visualization run
]

{ #category : 'accessing' }
MiButterflyNodeBeCentralNode >> group [ 

	^ 4
]

{ #category : 'accessing' }
MiButterflyNodeBeCentralNode >> label [

	^ 'Be central node'
]
