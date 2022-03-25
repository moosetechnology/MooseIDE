Class {
	#name : #MiCoTagVisualizationTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests'
}

{ #category : #tests }
MiCoTagVisualizationTest >> test01Legend [

	| v class legendTag tag1 tag2 |
	v := MiCoUsageMapBuilder new.
	class := MiCoTestClass.
	v godClass: class.
	legendTag := MiCoTagBuilder new.
	v
		legendTag: legendTag;
		build.
	self assert: legendTag shapes size equals: 1.
	tag1 := MiCoTag new
		name: 'Frame';
		color: Color lightBlue;
		yourself.
	legendTag addTag: tag1.
	tag2 := MiCoTag new
		name: 'Connection';
		color: Color green;
		yourself.
	legendTag addTag: tag2.
	v build.
	self assert: legendTag shapes size equals: 3
]
