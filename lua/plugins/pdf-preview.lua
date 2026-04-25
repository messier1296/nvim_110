local function first_executable(candidates)
  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then return candidate end
  end
end

local function pdf_viewer_settings()
  local viewer = first_executable { "sioyek", "zathura", "okular", "evince", "xdg-open", "open" }

  if viewer == "sioyek" then
    return {
      launch = "sioyek --new-window %outputfile%",
      refresh = "none",
    }
  end

  if viewer == "zathura" then
    return {
      launch = "zathura %outputfile%",
      refresh = "none",
      forward_jump = "zathura --synctex-forward=%line%:%column%:%srcfile% %outputfile%",
    }
  end

  if viewer == "okular" then
    return {
      launch = "okular --unique %outputfile%",
      refresh = "none",
      forward_jump = "okular --unique %outputfile%'#src:%line% '%srcfile%",
    }
  end

  if viewer == "evince" then
    return {
      launch = "evince %outputfile%",
      refresh = "none",
      forward_jump = "synctex view -i %line%:%column%:%srcfile% -o %outputfile% -x 'evince -i %{page+1} %outputfile%'",
    }
  end

  if viewer then
    return {
      launch = viewer .. " %outputfile%",
      refresh = "none",
    }
  end

  return {
    launch = "xdg-open %outputfile%",
    refresh = "none",
  }
end

local function viewer_open_command(path)
  local viewer = first_executable { "sioyek", "zathura", "okular", "evince", "xdg-open", "open" }

  if viewer == "sioyek" then return { viewer, "--new-window", path } end
  if viewer == "okular" then return { viewer, "--unique", path } end
  if viewer then return { viewer, path } end

  vim.notify("No PDF viewer command found", vim.log.levels.ERROR)
end

local function current_pdf_path()
  local path = vim.fn.expand "%:p"

  if path == "" then
    vim.notify("No file is associated with this buffer", vim.log.levels.ERROR)
    return
  end

  if vim.fn.filereadable(path) == 0 then
    vim.notify(("PDF file does not exist: %s"):format(path), vim.log.levels.ERROR)
    return
  end

  if vim.fn.fnamemodify(path, ":e"):lower() ~= "pdf" then
    vim.notify(("Current file is not a PDF: %s"):format(path), vim.log.levels.ERROR)
    return
  end

  return path
end

local function open_current_pdf()
  local path = current_pdf_path()
  if not path then return end

  local command = viewer_open_command(path)
  if not command then return end

  vim.system(command, { detach = true })
end

local function preview_once_or_open_pdf()
  if vim.fn.fnamemodify(vim.fn.expand "%:p", ":e"):lower() == "pdf" then
    open_current_pdf()
  else
    require("knap").process_once()
  end
end

local function toggle_preview_or_open_pdf()
  if vim.fn.fnamemodify(vim.fn.expand "%:p", ":e"):lower() == "pdf" then
    open_current_pdf()
  else
    require("knap").toggle_autopreviewing()
  end
end

return {
  {
    "frabjous/knap",
    ft = { "markdown", "tex", "plaintex", "typst", "pdf" },
    cmd = { "PdfOpen", "PdfPreviewToggle", "PdfPreviewOnce", "PdfPreviewClose", "PdfPreviewJump" },
    keys = {
      {
        "<leader>pp",
        toggle_preview_or_open_pdf,
        desc = "Open or Toggle PDF Preview",
      },
      {
        "<leader>po",
        preview_once_or_open_pdf,
        desc = "Open or Build PDF",
      },
      {
        "<leader>pc",
        function() require("knap").close_viewer() end,
        desc = "PDF Preview Close",
      },
      {
        "<leader>pj",
        function() require("knap").forward_jump() end,
        desc = "PDF Preview Jump",
      },
    },
    config = function()
      local viewer = pdf_viewer_settings()
      local tex_command = vim.fn.executable "latexmk" == 1
          and "latexmk -pdf -interaction=batchmode -halt-on-error -synctex=1 %docroot%"
        or "pdflatex -interaction=batchmode -halt-on-error -synctex=1 %docroot%"

      vim.g.knap_settings = {
        delay = 250,

        mdoutputext = "pdf",
        mdtopdf = "pandoc %docroot% -o %outputfile%",
        mdtopdfviewerlaunch = viewer.launch,
        mdtopdfviewerrefresh = viewer.refresh,

        markdownoutputext = "pdf",
        markdowntopdf = "pandoc %docroot% -o %outputfile%",
        markdowntopdfviewerlaunch = viewer.launch,
        markdowntopdfviewerrefresh = viewer.refresh,

        texoutputext = "pdf",
        textopdf = tex_command,
        textopdfviewerlaunch = viewer.launch,
        textopdfviewerrefresh = viewer.refresh,
        textopdfforwardjump = viewer.forward_jump or "false",

        plaintexoutputext = "pdf",
        plaintextopdf = tex_command,
        plaintextopdfviewerlaunch = viewer.launch,
        plaintextopdfviewerrefresh = viewer.refresh,
        plaintextopdfforwardjump = viewer.forward_jump or "false",

        typoutputext = "pdf",
        typtopdf = "typst compile %docroot% %outputfile%",
        typtopdfviewerlaunch = viewer.launch,
        typtopdfviewerrefresh = viewer.refresh,
      }

      vim.api.nvim_create_user_command("PdfPreviewToggle", function() require("knap").toggle_autopreviewing() end, {
        desc = "Toggle live PDF preview",
      })
      vim.api.nvim_create_user_command("PdfPreviewOnce", preview_once_or_open_pdf, {
        desc = "Build PDF once and open or refresh the viewer",
      })
      vim.api.nvim_create_user_command("PdfOpen", open_current_pdf, {
        desc = "Open the current PDF file in an external viewer",
      })
      vim.api.nvim_create_user_command("PdfPreviewClose", function() require("knap").close_viewer() end, {
        desc = "Close the PDF preview viewer",
      })
      vim.api.nvim_create_user_command("PdfPreviewJump", function() require("knap").forward_jump() end, {
        desc = "Jump the PDF viewer to the current source position when supported",
      })
    end,
  },
}
