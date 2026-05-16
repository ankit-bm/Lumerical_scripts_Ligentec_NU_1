from io import BytesIO
from PIL import Image
import win32clipboard


def copy_fig_to_clipboard(fig):
    """Copy a matplotlib figure to the Windows clipboard (Ctrl+C handler)."""
    buf = BytesIO()
    fig.savefig(buf, format='png', dpi=150, bbox_inches='tight')
    buf.seek(0)
    img = Image.open(buf)
    out = BytesIO()
    img.convert('RGB').save(out, 'BMP')
    data = out.getvalue()[14:]  # strip BMP file header
    win32clipboard.OpenClipboard()
    win32clipboard.EmptyClipboard()
    win32clipboard.SetClipboardData(win32clipboard.CF_DIB, data)
    win32clipboard.CloseClipboard()
    print("✅ Copied.")