Class {
	#name : #GtSourceCoderHeaderLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'header',
		'breadcrumb'
	],
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #initialization }
GtSourceCoderHeaderLook >> initialize [
	super initialize.
	
	breadcrumb := self newBreadcrumb.
	
	header := self newHeaderElement.
	header addChild: breadcrumb.

	self addChangeAddChildAs: #(content header) with: [ header ].
]

{ #category : #'instance creation' }
GtSourceCoderHeaderLook >> newBreadcrumb [
	<return: #BrBreadcrumb>

	^ GtCoderBreadcrumbElement new
		constraintsDo: [ :c | 
			c margin: (BlInsets top: 2).
			c frame horizontal alignLeft.
			c frame vertical alignCenter ];
		yourself
]

{ #category : #'instance creation' }
GtSourceCoderHeaderLook >> newHeaderElement [
	^ BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		yourself
]

{ #category : #initialization }
GtSourceCoderHeaderLook >> onCoderChanged: aGtSourceCoder [
	breadcrumb coder: aGtSourceCoder
]
