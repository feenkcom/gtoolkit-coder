Class {
	#name : #GtTextualCoderMenu,
	#superclass : #BrMenu,
	#instVars : [
		'coder',
		'coderViewModelStencil'
	],
	#category : #'GToolkit-Coder-UI-Menu'
}

{ #category : #visiting }
GtTextualCoderMenu >> acceptVisitor: aVisitor [
	^ aVisitor visitTextualCoderMenu: self
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

{ #category : #accessing }
GtTextualCoderMenu >> coderViewModelStencil [
	^ coderViewModelStencil
]

{ #category : #'api - initialization' }
GtTextualCoderMenu >> coderViewModelStencil: aCoderViewModelStencil [
	coderViewModelStencil := aCoderViewModelStencil asStencil
]
