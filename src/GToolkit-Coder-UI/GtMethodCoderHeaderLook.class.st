Class {
	#name : #GtMethodCoderHeaderLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'header',
		'breadcrumb'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #initialization }
GtMethodCoderHeaderLook >> initialize [
	super initialize.
	
	breadcrumb := self newBreadcrumb.
	
	header := self newHeaderElement.
	header addChild: breadcrumb.

	self addChangeAddChildAs: #(content header) with: [ header ].
]

{ #category : #'instance creation' }
GtMethodCoderHeaderLook >> newBreadcrumb [
	<return: #BrBreadcrumb>

	^ GtMethodCoderBreadcrumbElement new
		constraintsDo: [ :c | 
			c margin: (BlInsets top: 2).
			c frame horizontal alignLeft.
			c frame vertical alignCenter ];
		yourself
]

{ #category : #'instance creation' }
GtMethodCoderHeaderLook >> newHeaderElement [
	^ BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		yourself
]

{ #category : #initialization }
GtMethodCoderHeaderLook >> onCoderChanged: aGtSourceCoderUIModel [
	breadcrumb sourceCoderUIModel: aGtSourceCoderUIModel
]
