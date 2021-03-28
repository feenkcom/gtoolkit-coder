Class {
	#name : #GtMethodCoderHeaderAptitude,
	#superclass : #GtSourceCoderAptitude,
	#instVars : [
		'header',
		'breadcrumb'
	],
	#category : #'GToolkit-Coder-Pharo-UI-! Views'
}

{ #category : #initialization }
GtMethodCoderHeaderAptitude >> initialize [
	super initialize.
	
	breadcrumb := self newBreadcrumb.
	
	header := self newHeaderElement.
	header addChild: breadcrumb.

	self addChangeAddChildAs: #(content header) with: [ header ].
]

{ #category : #'instance creation' }
GtMethodCoderHeaderAptitude >> newBreadcrumb [
	<return: #BrBreadcrumb>

	^ GtMethodCoderBreadcrumbElement new
		constraintsDo: [ :c | 
			c margin: (BlInsets top: 2).
			c frame horizontal alignLeft.
			c frame vertical alignCenter ];
		yourself
]

{ #category : #'instance creation' }
GtMethodCoderHeaderAptitude >> newHeaderElement [
	^ BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		yourself
]

{ #category : #initialization }
GtMethodCoderHeaderAptitude >> onCoderChanged: aGtSourceCoderUIModel [
	breadcrumb sourceCoderUIModel: aGtSourceCoderUIModel
]
