Extension { #name : #BrGlamorousMenuElementBuilder }

{ #category : #'*GToolkit-Coder-UI' }
BrGlamorousMenuElementBuilder >> visitTextualCoderMenu: aMenuModel [
	| aCoderViewModel aCoderElement |
	aMenuModel coderViewModelStencil ifNil: [ ^ nil ].
	aCoderViewModel := aMenuModel coderViewModelStencil create.
	aCoderViewModel ifNil: [ ^ nil ].
	
	aCoderElement := aCoderViewModel asExpandedOnlyElement.
	aCoderElement
		hExact: 500;
		vFitContentLimited;
		background: aCoderElement theme default contentBackgroundColor;
		addAptitude: (BrGlamorousMenuPinnableAptitude new 
			menuModel: aMenuModel;
			withResizers;
			withAllPinActions);
		addAptitude: (BrMenuHideableAptitude new menuModel: aMenuModel);
		addAptitude: BrMenuCommonAptitude new.
		
	aMenuModel id ifNotNil: [ :anId |
		aCoderElement id: anId ].
	
	^ aCoderElement
]
