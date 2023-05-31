Class {
	#name : #GtPlaygroundEvaluatedCodeViewButtonAttribute,
	#superclass : #GtPlaygroundEvaluatedCodeButtonAttribute,
	#instVars : [
		'view'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Attributes'
}

{ #category : #accessing }
GtPlaygroundEvaluatedCodeViewButtonAttribute >> defaultView [
	^ #gtViewsFor:
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeViewButtonAttribute >> initialize [
	super initialize.

	self view: self defaultView
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeViewButtonAttribute >> playgroundElementIn: aContainer [
	^ (self result value perform: self view withArguments: {GtPhlowEmptyView new})
		asElementDo: [ :anInspectorElement | 
			aContainer
				addChild: ((anInspectorElement exact: 400 @ 400) asScalableElement size: 200 @ 200) ]
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeViewButtonAttribute >> view [
	^ view
]

{ #category : #accessing }
GtPlaygroundEvaluatedCodeViewButtonAttribute >> view: anObject [
	view := anObject
]
