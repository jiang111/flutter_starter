/// Holds the dimensions of a [StaggeredGridView]'s tile.
///
/// A [CStaggeredTile] always overlaps an exact number of cells in the cross
/// axis of a [StaggeredGridView].
/// The main axis extent can either be a number of pixels or a number of
/// cells to overlap.
class CStaggeredTile {
  /// Creates a [CStaggeredTile] with the given [crossAxisCellCount] and
  /// [mainAxisCellCount].
  ///
  /// The main axis extent of this tile will be the length of
  /// [mainAxisCellCount] cells (inner spacings included).
  const CStaggeredTile.count(this.crossAxisCellCount, this.mainAxisCellCount)
      : assert(crossAxisCellCount >= 0),
        assert(mainAxisCellCount != null && mainAxisCellCount >= 0),
        mainAxisExtent = null;

  /// Creates a [CStaggeredTile] with the given [crossAxisCellCount] and
  /// [mainAxisExtent].
  ///
  /// This tile will have a fixed main axis extent.
  const CStaggeredTile.extent(this.crossAxisCellCount, this.mainAxisExtent)
      : assert(crossAxisCellCount >= 0),
        assert(mainAxisExtent != null && mainAxisExtent >= 0),
        mainAxisCellCount = null;

  /// Creates a [CStaggeredTile] with the given [crossAxisCellCount] that
  /// fit its main axis extent to its content.
  ///
  /// This tile will have a fixed main axis extent.
  const CStaggeredTile.fit(this.crossAxisCellCount)
      : assert(crossAxisCellCount >= 0),
        mainAxisExtent = null,
        mainAxisCellCount = null;

  /// The number of cells occupied in the cross axis.
  final int crossAxisCellCount;

  /// The number of cells occupied in the main axis.
  final double? mainAxisCellCount;

  /// The number of pixels occupied in the main axis.
  final double? mainAxisExtent;

  bool get fitContent => mainAxisCellCount == null && mainAxisExtent == null;
}
