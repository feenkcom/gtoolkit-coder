Class {
	#name : #GtTextualCoderMenu,
	#superclass : #BrMenu,
	#instVars : [
		'coder',
		'coderViewModelStencil'
	],
	#category : #'GToolkit-Coder-UI-Menu'
}

{ #category : #'api - converting' }
GtTextualCoderMenu >> asElement [
	| aCoderViewModel aCoderElement |
	coderViewModelStencil ifNil: [ ^ nil ].
	aCoderViewModel := coderViewModelStencil create.
	aCoderViewModel ifNil: [ ^ nil ].
	
	aCoderElement := aCoderViewModel asExpandedOnlyElement.
	aCoderElement
		hExact: 500;
		vExact: 400;
		geometry: (BlChildrenWrappingGeometry cornerRadius: 4);
		background: aCoderElement theme default contentBackgroundColor;
		addAptitude: BrMenuPinnableAptitude new.
		
	self announcer weak
		when: BrMenuHideRequest
		send: #removeFromParent
		to: aCoderElement.
	^ aCoderElement
]

{ #category : #'api - initialization' }
GtTextualCoderMenu >> coder: aCoder [
	self coderViewModelStencil: [ aCoder asCoderViewModel ] asStencil
]

{ #category : #'api - initialization' }
GtTextualCoderMenu >> coderStencil: aCoderStencil [
	self coderViewModelStencil: [ aCoderStencil asStencil create asCoderViewModel ] asStencil
]

{ #category : #'api - initialization' }
GtTextualCoderMenu >> coderViewModel: aCoderViewModel [
	self coderViewModelStencil: [ aCoderViewModel ] asStencil
]

{ #category : #'api - initialization' }
GtTextualCoderMenu >> coderViewModelStencil: aCoderViewModelStencil [
	coderViewModelStencil := aCoderViewModelStencil asStencil
]
