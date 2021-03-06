/** \ingroup MapComposer
 * Graphics scene for map printing. The class manages the paper item which always
 * is the item in the back (z-value 0). It maintains the z-Values of the items and stores
 * them in a list in ascending z-Order. This list can be changed to lower/raise items one position
 * or to bring them to front/back.
 * */
class QgsComposition : QGraphicsScene
{
%TypeHeaderCode
#include <qgscomposition.h>
%End

  public:

    /** \brief Plot type */
    enum PlotStyle
    {
      Preview = 0, // Use cache etc
      Print,       // Render well
      Postscript   // Fonts need different scaling!
    };

    /**Style to draw the snapping grid*/
    enum GridStyle
    {
      Solid,
      Dots,
      Crosses
    };

    enum ZValueDirection
    {
      ZValueBelow,
      ZValueAbove
    };

    /**Composition atlas modes*/
    enum AtlasMode
    {
      AtlasOff,     // Composition is not being controlled by an atlas
      PreviewAtlas, // An atlas composition is being previewed in the app
      ExportAtlas   // The composition is being exported as an atlas
    };

    QgsComposition( QgsMapRenderer* mapRenderer );
    ~QgsComposition();

    /**Changes size of paper item*/
    void setPaperSize( double width, double height );

    /**Returns height of paper item*/
    double paperHeight() const;

    /**Returns width of paper item*/
    double paperWidth() const;

    double spaceBetweenPages() const;

    /**Note: added in version 1.9*/
    void setNumPages( int pages );
    /**Note: added in version 1.9*/
    int numPages() const;

    /**Note: added in version 2.1*/
    void setPageStyleSymbol( QgsFillSymbolV2* symbol /Transfer/ );
    /**Note: added in version 2.1*/
    QgsFillSymbolV2* pageStyleSymbol();

    /**Returns the position within a page of a point in the composition
      @note Added in QGIS 2.1
    */
    QPointF positionOnPage( const QPointF & position ) const;

    /**Returns the page number corresponding to a point in the composition
      @note Added in QGIS 2.1
    */
    int pageNumberForPoint( const QPointF & position ) const;

    /**Sets the status bar message for the composer window
      @note Added in QGIS 2.1
    */
    void setStatusMessage( const QString & message );

    /**Refreshes the composition when composer related options change
     *Note: added in version 2.1*/
    void updateSettings();

    void setSnapToGridEnabled( bool b );
    bool snapToGridEnabled() const;

    void setGridVisible( bool b );
    bool gridVisible() const;

    /**Hides / shows custom snap lines*/
    void setSnapLinesVisible( bool visible );
    bool snapLinesVisible() const;

    void setAlignmentSnap( bool s );
    bool alignmentSnap() const;

    void setSmartGuidesEnabled( bool b );
    bool smartGuidesEnabled() const;

    /**Removes all snap lines*/
    void clearSnapLines();

    void setSnapGridResolution( double r );
    double snapGridResolution() const;

    void setSnapGridTolerance( double tolerance );
    double snapGridTolerance() const;

    void setSnapGridOffsetX( double offset );
    double snapGridOffsetX() const;

    void setSnapGridOffsetY( double offset );
    double snapGridOffsetY() const;

    void setGridPen( const QPen& p );
    const QPen& gridPen() const;

    void setGridStyle( GridStyle s );
    GridStyle gridStyle() const;

    void setAlignmentSnapTolerance( double t );
    double alignmentSnapTolerance() const;

    /**Returns pointer to undo/redo command storage*/
    QUndoStack* undoStack();

    /**Returns the topmost composer item. Ignores mPaperItem*/
    QgsComposerItem* composerItemAt( const QPointF & position );

    /**Returns the highest composer item at a specified position which is below a specified item. Ignores mPaperItem
      @note Added in QGIS 2.1
    */
    QgsComposerItem* composerItemAt( const QPointF & position, const QgsComposerItem* belowItem );

    /** Returns the page number (0-bsaed) given a coordinate */
    int pageNumberAt( const QPointF& position ) const;

    /** Returns on which page number (0-based) is displayed an item */
    int itemPageNumber( const QgsComposerItem* ) const;

    QList<QgsComposerItem*> selectedComposerItems();

%If (QLISTCONSTPTR_CONVERSION)
    /**Returns pointers to all composer maps in the scene
      @note available in python bindings only with PyQt >= 4.8.4
      */
    QList<const QgsComposerMap*> composerMapItems() const;
%End

    /**Return composer items of a specific type*/
    // template<class T> void composerItems( QList<T*>& itemList );

    /**Returns the composer map with specified id
     @return QgsComposerMap or 0 pointer if the composer map item does not exist*/
    const QgsComposerMap* getComposerMapById( int id ) const;

    /*Returns the composer html with specified id (a string as named in the
      composer user interface item properties).
      @note Added in QGIS 2.0
      @param id - A QString representing the id of the item.
      @return QgsComposerHtml pointer or 0 pointer if no such item exists.
    */
    const QgsComposerHtml* getComposerHtmlByItem( QgsComposerItem *item ) const;

    /**Returns a composer item given its text identifier.
       Ids are not necessarely unique, but this function returns only one element.
      @note added in 2.0
      @param theId - A QString representing the identifier of the item to
        retrieve.
      @return QgsComposerItem pointer or 0 pointer if no such item exists.
      **/
    const QgsComposerItem* getComposerItemById( QString theId ) const;

    /**Returns a composer item given its unique identifier.
      @note added in 2.0
      @param theUuid A QString representing the UUID of the item to
      **/
    const QgsComposerItem* getComposerItemByUuid( QString theUuid ) const;

    int printResolution() const;
    void setPrintResolution( int dpi );

    bool printAsRaster() const;
    void setPrintAsRaster( bool enabled );

    bool generateWorldFile() const;
    void setGenerateWorldFile( bool enabled );

    QgsComposerMap* worldFileMap();
    void setWorldFileMap( QgsComposerMap* map );

    /**Returns true if a composition should use advanced effects such as blend modes
      @note added in 1.9*/
    bool useAdvancedEffects() const;
    /**Used to enable or disable advanced effects such as blend modes in a composition
      @note: added in version 1.9*/
    void setUseAdvancedEffects( bool effectsEnabled );

    /**Returns pointer to map renderer of qgis map canvas*/
    QgsMapRenderer* mapRenderer();

    QgsComposition::PlotStyle plotStyle() const;
    void setPlotStyle( QgsComposition::PlotStyle style );

    /**Returns the pixel font size for a font that has point size set.
     The result depends on the resolution (dpi) and of the preview mode. Each item that sets
    a font should call this function before drawing text*/
    int pixelFontSize( double pointSize ) const;

    /**Does the inverse calculation and returns points for pixels (equals to mm in QgsComposition)*/
    double pointFontSize( int pixelSize ) const;

    /**Writes settings to xml (paper dimension)*/
    bool writeXML( QDomElement& composerElem, QDomDocument& doc );

    /**Reads settings from xml file*/
    bool readXML( const QDomElement& compositionElem, const QDomDocument& doc );

    /**Load a template document
        @param doc template document
        @param substitutionMap map with text to replace. Text needs to be enclosed by brackets (e.g. '[text]' )
        @param addUndoCommands whether or not to add undo commands
      */
    bool loadFromTemplate( const QDomDocument& doc, QMap<QString, QString>* substitutionMap = 0, bool addUndoCommands = false );

    /**Add items from XML representation to the graphics scene (for project file reading, pasting items from clipboard)
      @param elem items parent element, e.g. \verbatim <Composer> \endverbatim or \verbatim <ComposerItemClipboard> \endverbatim
      @param doc xml document
      @param mapsToRestore for reading from project file: set preview move 'rectangle' to all maps and save the preview states to show composer maps on demand
      @param addUndoCommands insert AddItem commands if true (e.g. for copy/paste)
      @param pos item position. Optional, take position from xml if 0
      @param pasteInPlace whether the position should be kept but mapped to the page origin. (the page is the page under to the mouse cursor)
      @note not available in python bindings
     */
    // void addItemsFromXML( const QDomElement& elem, const QDomDocument& doc, QMap< QgsComposerMap*, int >* mapsToRestore = 0,
    //                      bool addUndoCommands = false, QPointF* pos = 0, bool pasteInPlace = false );

    /**Adds item to z list. Usually called from constructor of QgsComposerItem*/
    void addItemToZList( QgsComposerItem* item );
    /**Removes item from z list. Usually called from destructor of QgsComposerItem*/
    void removeItemFromZList( QgsComposerItem* item );

    //functions to move selected items in hierarchy
    void raiseSelectedItems();
    void raiseItem( QgsComposerItem* item );
    void lowerSelectedItems();
    void lowerItem( QgsComposerItem* item );
    void moveSelectedItemsToTop();
    void moveItemToTop( QgsComposerItem* item );
    void moveSelectedItemsToBottom();
    void moveItemToBottom( QgsComposerItem* item );

    //functions to find items by their position in the z list
    void selectNextByZOrder( ZValueDirection direction );
    QgsComposerItem* getComposerItemBelow( QgsComposerItem* item );
    QgsComposerItem* getComposerItemAbove( QgsComposerItem* item );

    //functions to align selected items
    void alignSelectedItemsLeft();
    void alignSelectedItemsHCenter();
    void alignSelectedItemsRight();
    void alignSelectedItemsTop();
    void alignSelectedItemsVCenter();
    void alignSelectedItemsBottom();

    //functions to lock and unlock items
    /**Lock the selected items*/
    void lockSelectedItems();
    /**Unlock all items*/
    void unlockAllItems();

    /**Sorts the zList. The only time where this function needs to be called is from QgsComposer
     after reading all the items from xml file*/
    void sortZList();

    /**Rebuilds the z order list based on current order of items in scene*/
    void refreshZList();

    /**Snaps a scene coordinate point to grid*/
    QPointF snapPointToGrid( const QPointF& scenePoint ) const;

    /**Returns pointer to snap lines collection*/
    QList< QGraphicsLineItem* >* snapLines();

    /**Returns pointer to selection handles
     * @note not available in python bindings
     */
    // QgsComposerMouseHandles* selectionHandles();

    /**Add a custom snap line (can be horizontal or vertical)*/
    QGraphicsLineItem* addSnapLine();
    /**Remove custom snap line (and delete the object)*/
    void removeSnapLine( QGraphicsLineItem* line );
    /**Get nearest snap line
     * @note not available in python bindings
     */
    // QGraphicsLineItem* nearestSnapLine( bool horizontal, double x, double y, double tolerance, QList< QPair< QgsComposerItem*, QgsComposerItem::ItemPositionMode > >& snappedItems );

    /**Allocates new item command and saves initial state in it
      @param item target item
      @param commandText descriptive command text
      @param c context for merge commands (unknown for non-mergeable commands)*/
    void beginCommand( QgsComposerItem* item, const QString& commandText, QgsComposerMergeCommand::Context c = QgsComposerMergeCommand::Unknown );

    /**Saves end state of item and pushes command to the undo history*/
    void endCommand();
    /**Deletes current command*/
    void cancelCommand();

    void beginMultiFrameCommand( QgsComposerMultiFrame* multiFrame, const QString& text );
    void endMultiFrameCommand();

    /**Adds multiframe. The object is owned by QgsComposition until removeMultiFrame is called*/
    void addMultiFrame( QgsComposerMultiFrame* multiFrame );
    /**Removes multi frame (but does not delete it)*/
    void removeMultiFrame( QgsComposerMultiFrame* multiFrame );
    /**Adds an arrow item to the graphics scene and advices composer to create a widget for it (through signal)
      @note not available in python bindings*/
    void addComposerArrow( QgsComposerArrow* arrow );
    /**Adds label to the graphics scene and advices composer to create a widget for it (through signal)*/
    void addComposerLabel( QgsComposerLabel* label );
    /**Adds map to the graphics scene and advices composer to create a widget for it (through signal)*/
    void addComposerMap( QgsComposerMap* map, bool setDefaultPreviewStyle = true );
    /**Adds scale bar to the graphics scene and advices composer to create a widget for it (through signal)*/
    void addComposerScaleBar( QgsComposerScaleBar* scaleBar );
    /**Adds legend to the graphics scene and advices composer to create a widget for it (through signal)*/
    void addComposerLegend( QgsComposerLegend* legend );
    /**Adds picture to the graphics scene and advices composer to create a widget for it (through signal)*/
    void addComposerPicture( QgsComposerPicture* picture );
    /**Adds a composer shape to the graphics scene and advices composer to create a widget for it (through signal)*/
    void addComposerShape( QgsComposerShape* shape );
    /**Adds a composer table to the graphics scene and advices composer to create a widget for it (through signal)*/
    void addComposerTable( QgsComposerAttributeTable* table );
    /**Adds composer html frame and advices composer to create a widget for it (through signal)*/
    void addComposerHtmlFrame( QgsComposerHtml* html /Transfer/, QgsComposerFrame* frame /Transfer/);

    /**Remove item from the graphics scene. Additionally to QGraphicsScene::removeItem, this function considers undo/redo command*/
    void removeComposerItem( QgsComposerItem* item, bool createCommand = true );

    /**Convenience function to create a QgsAddRemoveItemCommand, connect its signals and push it to the undo stack*/
    void pushAddRemoveCommand( QgsComposerItem* item, const QString& text, QgsAddRemoveItemCommand::State state = QgsAddRemoveItemCommand::Added );

    /**If true, prevents any mouse cursor changes by the composition or by any composer items
      Used by QgsComposer and QgsComposerView to prevent unwanted cursor changes*/
    void setPreventCursorChange( bool preventChange );
    bool preventCursorChange();

    //printing

    /** Prepare the printer for printing */
    void beginPrint( QPrinter& printer );
    /** Prepare the printer for printing in a PDF */
    void beginPrintAsPDF( QPrinter& printer, const QString& file );
    /** Print on a preconfigured printer */
    void doPrint( QPrinter& printer, QPainter& painter );

    /** Convenience function that prepares the printer and prints */
    void print( QPrinter &printer );

    /** Convenience function that prepares the printer for printing in PDF and prints */
    void exportAsPDF( const QString& file );

    //! print composer page to image
    //! If the image does not fit into memory, a null image is returned
    QImage printPageAsRaster( int page );

    /**Render a page to a paint device
        @note added in version 1.9*/
    void renderPage( QPainter* p, int page );

    /** Compute world file parameters */
    void computeWorldFileParameters( double& a, double& b, double& c, double& d, double& e, double& f ) const;

    QgsAtlasComposition& atlasComposition();

    /**Resizes a QRectF relative to the change from boundsBefore to boundsAfter*/
    static void relativeResizeRect( QRectF& rectToResize, const QRectF& boundsBefore, const QRectF& boundsAfter );
    /**Returns a scaled position given a before and after range*/
    static double relativePosition( double position, double beforeMin, double beforeMax, double afterMin, double afterMax );

    /** Returns the current atlas mode of the composition */
    QgsComposition::AtlasMode atlasMode() const;
    /** Sets the current atlas mode of the composition. Returns false if the mode could not be changed. */
    bool setAtlasMode( QgsComposition::AtlasMode mode );

  public slots:
    /**Casts object to the proper subclass type and calls corresponding itemAdded signal*/
    void sendItemAddedSignal( QgsComposerItem* item );
  signals:
    void paperSizeChanged();
    void nPagesChanged();

    /**Is emitted when selected item changed. If 0, no item is selected*/
    void selectedItemChanged( QgsComposerItem* selected );
    /**Is emitted when new composer arrow has been added to the view*/
    void composerArrowAdded( QgsComposerArrow* arrow );
    /**Is emitted when a new composer html has been added to the view*/
    void composerHtmlFrameAdded( QgsComposerHtml* html, QgsComposerFrame* frame );
    /**Is emitted when new composer label has been added to the view*/
    void composerLabelAdded( QgsComposerLabel* label );
    /**Is emitted when new composer map has been added to the view*/
    void composerMapAdded( QgsComposerMap* map );
    /**Is emitted when new composer scale bar has been added*/
    void composerScaleBarAdded( QgsComposerScaleBar* scalebar );
    /**Is emitted when a new composer legend has been added*/
    void composerLegendAdded( QgsComposerLegend* legend );
    /**Is emitted when a new composer picture has been added*/
    void composerPictureAdded( QgsComposerPicture* picture );
    /**Is emitted when a new composer shape has been added*/
    void composerShapeAdded( QgsComposerShape* shape );
    /**Is emitted when a new composer table has been added*/
    void composerTableAdded( QgsComposerAttributeTable* table );
    /**Is emitted when a composer item has been removed from the scene*/
    void itemRemoved( QgsComposerItem* );
};
