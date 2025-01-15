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
		vFitContentLimited;
		background: aCoderElement theme default contentBackgroundColor;
		addAptitude: BrGlamorousFocusableShadowAptitude new;
		addAptitude: (BrMenuPinnableAptitude new 
			menuModel: self;
			withResizers;
			withAllPinActions);
		addAptitude: (BrMenuHideableAptitude new menuModel: self);
		addAptitude: BrMenuCommonAptitude new.
	
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
